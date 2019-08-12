fetch('./func_test.wasm').then( response => 
	response.arrayBuffer()	
).then( bytes => 
	WebAssembly.instantiate(bytes)	
).then( results => {
	console.log("Wasm module loaded");
	instance = results.instance;
	console.log("instance", instance);

	var black = 1;
	var white = 2;
	var c_black = 5;
	var c_white = 6;

	console.log("Calling offset");
	var offset = instance.exports.offsetPosition(3,4);
	console.log("Offset for (3,4): ", offset);

	console.debug("Black is black? ", instance.exports.isBlack(black));
	console.debug("White is white? ", instance.exports.isWhite(white));
	console.debug("Black is white? ", instance.exports.isWhite(black));
	console.debug("Uncrowned white ", instance.exports.isWhite(instance.exports.removeCrown(c_white)));
	console.debug("Crowned is crowned ", instance.exports.isCrowned(c_black));
})