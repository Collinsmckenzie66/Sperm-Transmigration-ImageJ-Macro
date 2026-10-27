// This macro chops an image into NxN tiles, 
// where N is the number of divisions chosen by the user.

// Batch:
run("Close All"); 

// Prompt user to select a folder
inputDir = getDirectory("Choose a folder containing tiles");
// Create results folder
resultsDir = inputDir + "Results" + File.separator;
// Check if the Results folder exists
if (!File.exists(resultsDir)) {
    File.makeDirectory(resultsDir);
    print("Results folder created");
} else {
    print("Results folder already exists");
}


// Get a list of all .tif files in the folder
fileList = getFileList(inputDir);
for (i = 0; i < fileList.length; i++) {
	if (endsWith(fileList[i], ".tif")) {
		filePath = inputDir + fileList[i];
		IJ.log("Processing file: "+fileList[i]);
		
		open(filePath);
		//run("Bio-Formats Importer", "open=[" + filePath + "]"); only neededto open a czi
		
		// select the same rectangle everytime
		//makeRectangle(256, 96, 18800, 1104);
		run("Specify...", "width=18800 height=1100 x=200 y=96");
		run("Crop");
		
		id = getImageID(); 
		title = getTitle(); 
		getLocationAndSize(locX, locY, sizeW, sizeH); 
		width = getWidth(); 
		height = getHeight(); 
		tileWidth = width / 6; 
		tileHeight = height / 1; 
		for (y = 0; y < 1; y++) { 
		offsetY = y * height / 1; 
		 for (x = 0; x < 6; x++) { 
		offsetX = x * width / 6; 
		selectImage(id); 
		 call("ij.gui.ImageWindow.setNextLocation", locX + offsetX, locY + offsetY); 
		tileTitle = title + " [" + x + "," + y + "]"; 
		 run("Duplicate...", "title=" + tileTitle); 
		makeRectangle(offsetX, offsetY, tileWidth, tileHeight); 
		 run("Crop");} } 
		selectImage(id); 
		close(); 
		
		
		// Run the "Images to Stack" command with the user-defined name
		run("Images to Stack", "name=" + fileList[i] + " use");
		
		run("Subtract Background...", "rolling=10 stack");
		
		run("Next Slice [>]");
		run("Next Slice [>]");
		run("Next Slice [>]");
		run("Next Slice [>]");
		run("Next Slice [>]");
		resetMinAndMax;
		run("Previous Slice [<]");
		run("Previous Slice [<]");
		run("Previous Slice [<]");
		run("Previous Slice [<]");
		run("Previous Slice [<]");
		
		//Change these thresholds accordingly!!!!!
		
		//P6, 1st image in stack
		resetMinAndMax;
		setMinAndMax(28, 998);
		run("Apply LUT", "slice");
		run("Next Slice [>]");
		
		//P5, 2nd image in stack
		resetMinAndMax;
		setMinAndMax(33, 840);
		run("Apply LUT", "slice");
		run("Next Slice [>]");
		
		
		//P4, 3rd image in stack
		resetMinAndMax;
		setMinAndMax(55, 550);
		run("Apply LUT", "slice");
		run("Next Slice [>]");
		
		
		//P3, 4th image in stack
		resetMinAndMax;
		run("Enhance Contrast", "saturated=0.35");
		run("Apply LUT", "slice");
		run("Next Slice [>]");
		
		
		//P2, 5th image in stack
		resetMinAndMax;
		run("Enhance Contrast", "saturated=0.35");
		run("Apply LUT", "slice");
		run("Next Slice [>]");
		
		
		//P1, 6th image in stack
		resetMinAndMax;
		run("Enhance Contrast", "saturated=0.35");
		run("Apply LUT", "slice");
		run("Next Slice [>]");
		
		run("Set Scale...", "distance=0.7692 known=1 unit=micron");
		setAutoThreshold("Default dark no-reset");
		setOption("BlackBackground", true);
		run("Convert to Mask", "background=Dark black create");
		
		run("Previous Slice [<]");
		run("Previous Slice [<]");
		run("Previous Slice [<]");
		run("Previous Slice [<]");
		run("Previous Slice [<]");
		
		run("Despeckle", "stack");
		run("Next Slice [>]");
		run("Despeckle", "stack");
		run("Next Slice [>]");
		run("Next Slice [>]");
		run("Next Slice [>]");
		run("Next Slice [>]");
		
		
		//Can change the range in analyze particles as well
		run("Set Measurements...", "mean integrated area_fraction redirect=None decimal=3");
		run("Analyze Particles...", "size=15-1000 pixel  show=Overlay clear summarize overlay stack");
		run("Measure Stack...");
		//String.copyResults;
		
		// save results
		spaceIndex = indexOf(title, " ");
if (spaceIndex == -1) {
    title_before_space = title;
} else {
    title_before_space = substring(title, 0, spaceIndex);
}

		selectWindow("Results");
		saveAs("Results", resultsDir+"area_"+title+".csv");
		selectWindow("Summary of MASK_"+title_before_space);
		saveAs("Results", resultsDir+"count_"+title+".csv");
		
		// save images
		selectImage(title_before_space);
		saveAs("Tif", resultsDir+"stack_"+title+".tif");
		selectImage("MASK_"+title_before_space);
		saveAs("Tif", resultsDir+"mask_"+title+".tif");
		
		//waitForUser;
		
		run("Close All");
		run("Clear Results");
	}
}
	
