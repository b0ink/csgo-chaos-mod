/*
	- This PreCompiler is hopefully a temporary workflow until macro concatenation is supported in sourcepawn
*/



//TODO: Calculate what lines Chaos_Full.sp would be on the sourcemap, so that "line 5049 in Chaos.sp" can translate to "line 32 in Effect/X.sp"

const fs = require('fs');
const path = require('path');
const fsExtra = require('fs-extra');

const SOURCE_DIR =   '../GameServer/addons/sourcemod/scripting/';
const SOURCE_ENTRY = '../GameServer/addons/sourcemod/scripting/Chaos.sp';
const OUTPUT = './csgo-chaos-mod/';


var effect = ''; // Keep track of effect file
var chunk = ''; // Final chunk to save to Chaos_Full
var chunks = {}; // Chunks to keep track of 'sourcemap'


const DEV = true; // Set false to compress src and remove whitespace. Set true to preserve line count and indentation.
const sourcemap = true; // Set false to generate a single Chaos.sp (production), set true to recreate file & folder structure (Debug sourcemod errors)


async function compile(){
	await fsExtra.emptyDir(OUTPUT);
	setTimeout(() => {
		parseFile(SOURCE_ENTRY);
	}, 500);
}


compile();


async function parseFile(path, options = {}){
	chunks[path] = '';
 	effect = '';
	const data = await fs.promises.readFile(path, 'utf-8');
	let updateFile = true;

	let lines = data.split('\n')

	let isBlockedComment = false;
	for(let line of lines){

		// Condense src - Removes empty lines, indentation, comments, and white space 
		if(!DEV){
			line = line.trim();
			//TODO: allow debug option to allow all this vvv
			if(line.startsWith("//")) continue;
			if(!line) continue;
			if(line == '') continue;
			if(line == '\n') continue;
			if(line.trim() == '') continue;
			if(line.replaceAll(' ', '') == '') continue;
			if(line.replaceAll('	', '') == '') continue;
			if(line.indexOf('*/') != -1 && isBlockedComment){
				isBlockedComment = false;
				continue;
			}
			
	
			if(line.startsWith('/*')){
				isBlockedComment = true;
				continue;
			}


			if(isBlockedComment) continue;
	
			let commentIndex = line.indexOf("//");
			if(commentIndex != -1){
				if(line.indexOf("https") == -1 && line.indexOf('"') == -1){
					line = line.substring(0, commentIndex);
				}
			}
	
		}

		// Read current effect prefix
		if(line.trim().startsWith("#define EFFECTNAME ")){
			// chunk += `#undef EFFECTNAME\n`;
			effect = line.split("#define EFFECTNAME ")[1];
			effect = effect.replaceAll('\n', '');
			chunks[path] += '\n'; // preserve line count as source
			continue;
		}

		// Replace aliases
		if(effect){
			effect = effect.replace(/(\r\n|\n|\r)/gm, "");
			if(line.trim().startsWith("ONMAPSTART")) 	line = line.trim().replace("ONMAPSTART(", `public void Chaos_${effect}_OnMapStart(`);
			if(line.trim().startsWith("START")) 		line = line.trim().replace("START(", `public void Chaos_${effect}_START(`);
			if(line.trim().startsWith("SETUP")) 		line = line.trim().replace("SETUP(", `public void Chaos_${effect}(`);
			if(line.trim().startsWith("INIT")) 			line = line.trim().replace("INIT(", `public void Chaos_${effect}_INIT(`);
			if(line.trim().startsWith("CONDITIONS")) 	line = line.trim().replace("CONDITIONS()", `public bool Chaos_${effect}_Conditions()`);
			if(line.trim().startsWith("RESET")) 		line = line.trim().replace("RESET(", `public void Chaos_${effect}_RESET(`);
		}


		// Read includes
		let tryInclude = line.trim();
		if(tryInclude.startsWith('#include "')){
			let newPath = tryInclude.split('#include "')[1];
			newPath = newPath.split('"')[0];

			newPath = SOURCE_DIR + newPath;
			updateFile = false;
			await parseFile(newPath);
			if(!sourcemap){
				continue;
			}
		}

		if(line !== undefined){
			chunks[path] += `${line}\n`;
			chunk += `${line}\n`;
		}

	}
	if(sourcemap){
		let sourcePath = OUTPUT + path.split(SOURCE_DIR)[1];
		ensureDirectoryExistence(sourcePath);
		if(chunks[path].substring(chunks[path].length -2) === '\n'){
			chunks[path] =  chunks[path].substring(0, chunks[path].length -2)// trim end new line
		}
		await fs.promises.writeFile(sourcePath, chunks[path]);
	}else{
		if(updateFile){
			// TODO: send this to ../GameServer/addons/sourcemod/scripting/Chaos_Full.sp
			await fs.promises.writeFile(`${OUTPUT}Chaos.sp`, chunk)
		}
	}


}

// Recursive folder writing
function ensureDirectoryExistence(filePath) {
	let dirname = path.dirname(filePath);
	if (fs.existsSync(dirname)) {
	  return true;
	}
	ensureDirectoryExistence(dirname);
	fs.mkdirSync(dirname);
  }

// async function precompile(){
  	//TODO: automatically add effect names into EffectList.sp and EffectNames.sp
// }