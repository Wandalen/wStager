
let _ = require( '..' );

/* */

debugger;
let stager = new _.Stager
({
  object : {},
  stageNames : [ 'formed', 'willFilesFound', 'willFilesOpened', 'resourcesFormed' ],
  consequenceNames : [ 'formReady', 'willFilesFindReady', 'willFilesOpenReady', 'resourcesFormReady' ],
  finals : [ 3, 2, 2, 2 ],
  verbosity : 1,
});
