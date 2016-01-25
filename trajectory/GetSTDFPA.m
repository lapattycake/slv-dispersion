function [ FPA ] = GetSTDFPA( infile )
% GETSTDFPA
% 
% Objective: Calculate the standard deviation in the flight path angle
%   of the rocket, to be used in calculating the boost phase trajectory.
%
% input variables:
%   infile - input data file from which to load variables
%
% output variables:
%   FPA - the standard deviation on the flight path angle, in rad
%
% functions called:
%   none
%

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%
% File Handling
%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Open the rocket properties file
%
fileID = fopen(infile);
errmsg = sprintf('No %s found in local folder. Please specify a new file.', infile);
%
% Check that the default file opened properly
% While no valid file is open, ask for a new one
% If the file we asked for is invalid, try appending .txt
%
while fileID < 0
    disp(errmsg);
    filename = input('Open file: ', 's');
    [fileID, errmsg] = fopen(filename);
    if fileID == -1
        filename = sprintf('%s.txt', filename);
        [fileID, errmsg] = fopen(filename);
    end
end
fprintf('done!\n');
%
% Scan the properties text file for contents, string = value
% Use comments styled like Matlab, %
%
RProp = textscan(fileID, '%s = %f', 'CommentStyle', '%');
fclose(fileID);
%
% Read the properties text file contents
%
[m, n] = size(RProp{1});
tburn = false;
for i=1:m
    switch RProp{1}{i}
        % --Fin Properties--
        case 'fins'
            Nfin = RProp{2}(i); % Number of fins
        case 'root'
            c_R = RProp{2}(i); %[m] root chord
        case 'tip'
            c_T = RProp{2}(i); %[m] tip chord
        case 'height'
            fin_height = RProp{2}(i); %[m] fin height
        
        % --Rocket Body Properties--
        case 'drymass'
            dryM = RProp{2}(i); %[kg] mass of structure+propellant
        case 'wetmass'
            wetM = RProp{2}(i); %[kg] mass of structure+propellant
        case 'radius'
            r = RProp{2}(i); %[m]radius of body
        case 'centermass'
            C_G = RProp{2}(i); %[m] center of mass (from OpenRocket)
        case 'centerpressure'
            C_P = RProp{2}(i); %[m] center of pressure (from OpenRocket)
        case 'length'
            L_R = RProp{2}(i); %[m] rocket total length
        
            
        
        % --Motor Properties--
        case 'thrust'
            T = RProp{2}(i); %[N] thrust
        case 'Isp'
            Isp = RProp{2}(i); %[s] specific impulse
        case 'Itot'
            Itot = RProp{2}(i); %[N-s] total impulse
        case 'burn'
            tburn = RProp{2}(i); %[s]An option to override the burn time
            
        % --Simulation Properties--
        case 'res'
            res = RProp{2}(i); %[N] thrust  
   
    end
end

% End function
end