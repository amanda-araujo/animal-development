inputDir = getDirectory("Select input");
outputDir = getDirectory("Select output");

fileList = getFileList(inputDir);

setBatchMode(true);

/*
// Open all images and convert them to a stack
for (i = 0; i < list.length; i++) 
{
    open(inputDir + list[i]);
}
run("Images to Stack", "name=Stack title=[] use");

// Perform average intensity projection
run("Z Project...", "projection=[Average Intensity]");

// Save the averaged image
outputPath = outputDir + File.separator + "averagedImage.tif";
saveAs("Tiff", outputPath);

// Path to the averaged image
averagedImagePath = File.openDialog("Choose the averaged image...");
*/
sizeArray = newArray(fileList.length);
lengthArray = newArray(fileList.length);
widthArray = newArray(fileList.length);
print("Start processing, total "+fileList.length+" files");

for (i = 0; i < fileList.length; i++) 
{
	print("Process "+i);
	//erase backround
    open(inputDir + fileList[i]);
    run("8-bit");
    run("Subtract Background...", "rolling=2000");
    //run("Enhance Contrast", "saturated=0.35");
    run("Apply LUT");
    run("Convert to Mask");
    //preprocess
    run("Gaussian Blur...", "sigma=4");
	setAutoThreshold("Default dark no-reset");
	setThreshold(150, 255);
	run("Convert to Mask");
	//measure size
	run("Analyze Particles...", " display exclude clear include");
	selectWindow("Results");
	n = nResults();
	
	maxSize = getResult("Area", 0);
	maxLength = getResult("Major", 0);
	maxWidth = getResult("Minor", 0);
	for (j=1; j<n; j++) 
	{
        area = getResult("Area", j);
        length = getResult("Major", j);
        width = getResult("Minor", j);
        if (area > maxSize) 
        {
            maxSize = area;
            maxLength = length;
            maxWidth = width;
        } 
    }
    sizeArray[i]=maxSize;
    lengthArray[i]=maxLength;
    widthArray[i]=maxWidth;
    
	close("Results");
	saveAs("Tiff", outputDir + "processed_" + i);
        
    close();
}

//save size data
sizeString = "";
lengthString = "";
widthString = "";

for (i = 0; i < fileList.length; i++) 
{
    sizeString = sizeString+sizeArray[i]+"\n";
    lengthString = lengthString+lengthArray[i]+"\n";
    widthString = widthString+widthArray[i]+"\n";
}

File.saveString(sizeString, outputDir + "size.txt");
File.saveString(lengthString, outputDir + "length.txt");
File.saveString(widthString, outputDir + "width.txt");

setBatchMode(false);

