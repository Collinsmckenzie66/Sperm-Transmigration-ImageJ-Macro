###This macro is used to analyze tiled images taken by a Zeiss Axio microscope. It splits the image, that has been pre-straightened using the rotated rectangle function in FIJI, into 6 regions (or positions as some literature may refer to them as).\

#To use this macro:
Download it and simply drag the file into the ImageJ/FIJI interface. Press run and select the folder with your pre-straightened, stitched images and press run.\

#Edits you can Make to the Script:
1. On lines 40 and 41, the desired image height and width can be edited to adjust the number of positions or regions that the stitched image is split into. This allows for a more complex analysis of fluorescence by region. #NOTE: If you change these numbers, lines 60-71 will need to be altered to include more/less next slice and previous slice steps, and New code will need to be either inserted or deleted before Line 75 to add more image processing steps.
2. Lines 75-113 include a set of image processing steps that adjust the histogram for each image that worked for our purpose, but other projects may have different requirements. Feel free to change the histogram range for your applications.
3. The particle analysis used has a range of 15-1000 pixels on line 137. Feel free to adjust this range as you see fit for your application. 
