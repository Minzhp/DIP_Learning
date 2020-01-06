function createGif(inPath, num, delayTime, outFileName)
for i = 1:num
    imFileName = [inPath, num2str(i), '.png' ];
    image = imread(imFileName);
    [im, map] = rgb2ind(image, 100);
    if i == 1
        imwrite(im, map, [outFileName, '.gif'], 'gif', 'loopcount', inf, 'DelayTime', delayTime);
    else
        imwrite(im, map, [outFileName, '.gif'], 'gif', 'WriteMode', 'append', 'DelayTime', delayTime);
    end
end