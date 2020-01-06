function outputImage = extract(image, imageMark, mark)
outputImage = image;
if (length(size(image)) == 2)
    imageMark_ = imageMark == mark;
elseif (length(size(image)) == 3)
    imageMark_ = repmat(imageMark == mark, 1, 1, 3);
end
outputImage(~imageMark_) = 1;