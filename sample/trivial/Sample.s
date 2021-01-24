
let _ = require( '..' );

/* */

debugger;
// let stager = new _.Stager
// ({
//   object : {},
//   stageNames : [ 'formed', 'willFilesFound', 'willFilesOpened', 'resourcesFormed' ],
//   // consequenceNames : [ 'formReady', 'willFilesFindReady', 'willFilesOpenReady', 'resourcesFormReady' ],
//   // finals : [ 3, 2, 2, 2 ],
//   verbosity : 1,
// });

let object = Object.create( null );
object.stage1 = 0;
object.stage2 = 0;
object.stage3 = 0;
object.ready1 = new _.Consequence();
object.ready2 = new _.Consequence();
object.ready3 = new _.Consequence();

let stager = new _.Stager
({
  object,
  verbosity : 5,
  stageNames : [ 'stage1', 'stage2', 'stage3' ],
  consequences : [ 'ready1', 'ready2', 'ready3' ],
});

console.log( stager );
