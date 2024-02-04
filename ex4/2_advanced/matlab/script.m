util_functions;

%% Before simulation

% Create ASCII stimulus file 'faded_lake.txt' from PNG image.
png2ascii('../simvectors/faded_lake.png');

% Create expected output picture 'sat_lake.png' through MATLAB calculations.
sat_pic = saturate('../simvectors/faded_lake.png', 3);
imwrite(sat_pic, '../simvectors/sat_lake.png');

% Create expected response ASCII file 'sat_lake.txt' from PNG image.
png2ascii('../simvectors/sat_lake.png');

%% After simulation

% Create PNG image from actual responses in ASCII text file.
ascii2png('../simvectors/output.txt', '../simvectors/faded_lake.png');