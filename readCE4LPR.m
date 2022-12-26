function [data, refpos] = readCE4LPR(path)
% input CE4 LPR 2B data path
% output CE4 LPR 2B science data matrix (data_type: single) and the reference point position (Unit: m)
% Each column of the science data contains 2048 samples, with a sample interval of 0.3125ns.
% The xposition, yposition and zposition of reference ponit are based on Landing-site Regional Coordinate System, with coordinate center representing CE4 Lander.
% The x axis points to east and the y axis points to north and the z axis points to zenith.
% 

    scidata = fopen(path,'r','b'); %open science data file
    
    s = dir(path);
    recordlength = 8307;
    nrows = s.bytes / recordlength; % total columns
    
    xposition = zeros(nrows,1);
    yposition = zeros(nrows,1);
    zposition = zeros(nrows,1);


    fseek(scidata,38,'bof');
    for n=1:nrows
        xposition(n) = fread(scidata, [1, 1],'single',8303,'l');
    end

    fseek(scidata,42,'bof');
    for n=1:nrows
        yposition(n) = fread(scidata, [1, 1],'single',8303,'l');
    end

    fseek(scidata,46,'bof');
    for n=1:nrows
        zposition(n) = fread(scidata, [1, 1],'single',8303,'l');
    end
    
    refpos.x = xposition;
    refpos.y = yposition;
    refpos.z = zposition;


    skipbytes = 114;
    fseek(scidata,skipbytes,'bof'); %Skip ancillary data header on first line
    data = zeros(nrows, 2048); % 2048 samples of each column
    
    for n=1:nrows
        row = fread(scidata, [1, 2048],'2048*single',skipbytes+1,'l'); %read the individual data rows
        data(n,:) = row; %write each row to A
    end

    data=data';
    fclose(scidata);
    
end