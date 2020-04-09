function xyz_gridding_surfer_any
%__________________________________________________________________________
% 1) Description:
% This script creates a grid from irregularly spaced XYZ data, using Surfer 8.
% It is only necessarly to run the function.
%
% 2) Syntax:
%  xyz_gridding_surfer_any
%
% 3) Notes:
% It is very important to take account the DATA MUST BE into a TXT or DAT file.
% This file must only have three columns and the % arrangement of these columns in file,
% it would be:
% - First column : X data; 
% - Second column:  Y values and finally,
% - Third column : Z data.
%
% Please, check the file does not have any row with strings or characters.
%
% In command window, you can select the Gridding method for your data.   
%
%
% References:
% - Golden Surfer, Inc. (2002). Surfer User's Guide.
%             Colorado. 664 pp.
% - Hanselman, D. and Littlefield, B. (2005). Mastering
%             Matlab 7. Pearson Prentice Hall, Upper Sanddle
%             River. 852 pp.
%
% Thanks to Alberto Avila Armella to review this script.
%
% This script was done by Gabriel Ruiz Martinez.
% December, 2008
% v1
%__________________________________________________________________________

dirscript = cd;
clc; 
[archivo,pathn] = uigetfile({ '*.txt', 'ASCII Data (*.txt)'; '*.dat', 'GS Data (*.dat)' }, 'Select the file with X, Y, Z data');
if isequal(archivo,0)
    clear archivo pathn
    disp('User pushed Cancel')
else
    cdfiledatos = fullfile(pathn, archivo);
    [pathstr, name, exte] = fileparts(archivo);
    [met,ext,extension] = choosemet;
    lonno = length(archivo);
    if (met >= 1 && met <= 9 ) && ( ext >= 1 && ext <= 3)
       nombre = horzcat(archivo(1:1:lonno - 4), 'Grid', extension);
           try
              if strcmp(exte, '.DAT')
                  DataFile = csvread(cdfiledatos);
              else
                  DataFile = textread(cdfiledatos);
              end
              enu = {'X spacing:','Y spacing:'}; tit = 'Delta:'; lin = 1;
              valo = {'',''}; resp = inputdlg(enu,tit,lin,valo);
              a = str2num(resp{1,1}); b = str2num(resp{2,1});
              DataFilexm = min(DataFile(:,1)); DataFilexmax = max(DataFile(:,1));
              DataFileym = min(DataFile(:,2)); DataFileymax = max(DataFile(:,2));
              xCols = [ ]; yCols = [ ]; zCols = [ ]; ExclusionFilter = [ ];
              DupMethod = [ ]; xDupTol = [ ]; yDupTol = [ ];                     
              NumCols = (DataFilexmax-DataFilexm)/a;
              NumRows= (DataFileymax-DataFileym)/b;                  
              xMin = DataFilexm; xMax = DataFilexmax;
              yMin = DataFileym; yMax = DataFileymax;
              Algorithm = met; ShowReport = 0; SearchEnable =  [ ];
              SearchNumSectors = [ ]; SearchRad1 = [ ];SearchRad2 = [ ];
              SearchAngle = [ ]; SearchMinData = [ ];SearchDataPerSect = [ ];
              SearchMaxEmpty = [ ]; FaultFileName = [ ]; BreakFileName = [ ];
              AnisotropyRatio = [ ]; AnisotropyAngle = [ ]; IDPower = [ ];
              IDSmoothing = [ ]; KrigType = [ ]; KrigDriftType = [ ];
              KrigStdDevGrid = [ ]; KrigVariogram = [ ]; MCMaxResidual = [ ];
              MCMaxIterations = [ ]; MCInternalTension = [ ];
              MCBoundaryTension = [ ];MCRelaxationFactor = [ ];
              ShepSmoothFactor = [ ];ShepQuadraticNeighbors = [ ];
              ShepWeightingNeighbors = [ ]; ShepRange1 = [ ]; ShepRange2 = [ ];
              RegrMaxXOrder = [ ]; RegrMaxYOrder = [ ]; RegrMaxTotalOrder = [ ];
              RBBasisType = [ ];RBRSquared = [ ];
              OutGrid = nombre;
              if strcmp(extension,'.dat')
                  OutFmt = 3;
              else    
                  OutFmt = 2;
              end
              SearchMaxData = [ ]; KrigStdDevFormat = [ ]; DataMetric = [ ];
              LocalPolyOrder = [ ]; LocalPolyPower = [ ]; TriangleFileName = [ ];       
              SurferApp = actxserver('Surfer.Application');
              SurferApp.DefaultFilePath = dirscript;
              disp('Data are been interpolated at this moment... please, wait a little...!');
              invoke(SurferApp, 'GridData' , cdfiledatos, xCols, yCols, zCols, ExclusionFilter, ...
                    DupMethod, xDupTol,  yDupTol, NumCols, NumRows, ...
                    xMin, xMax, yMin, yMax, Algorithm, ...
                    ShowReport, SearchEnable, SearchNumSectors, ...
                    SearchRad1,SearchRad2, SearchAngle, SearchMinData, ...
                    SearchDataPerSect, SearchMaxEmpty, FaultFileName, ...
                    BreakFileName, AnisotropyRatio, AnisotropyAngle, ...
                    IDPower, IDSmoothing, KrigType, KrigDriftType, KrigStdDevGrid, ...
                    KrigVariogram, MCMaxResidual, MCMaxIterations,  ...
                    MCInternalTension, MCBoundaryTension, MCRelaxationFactor, ...
                    ShepSmoothFactor, ShepQuadraticNeighbors, ...
                    ShepWeightingNeighbors, ShepRange1, ShepRange2, ...
                    RegrMaxXOrder, RegrMaxYOrder, RegrMaxTotalOrder, ...
                    RBBasisType, RBRSquared, OutGrid, OutFmt, SearchMaxData, ...
                    KrigStdDevFormat, DataMetric, LocalPolyOrder, LocalPolyPower, ...
                    TriangleFileName );
              invoke(SurferApp, 'Quit');
              SurferApp.delete;
              disp('The grid file has been saved in the current path');
           catch
              mist = lasterror;
              errormsg = mist.message;
              invoke(SurferApp, 'Quit');
              SurferApp.delete;
              herror =msgbox(errormsg, 'Fatal error',  'error');
           end
       else
           disp('User does not select any gridding method');
    end      
end
return

% ***************************
% * S U B F U N C T I O N S *
% ***************************
function [met,ext,extension] = choosemet
fprintf('Please, choose a Gridding method: \n');
fprintf('  1) Kringing \n');
fprintf('  2) Inverse distance to a power \n');
fprintf('  3) Minimum Curvature \n');
fprintf('  4) Modified Shepard_s mode \n');
fprintf('  5) Natural Neighbor \n');
fprintf('  6) Nearest Neighbor \n');
fprintf('  7) Polynomial Regression \n');
fprintf('  8) Radial Basis Function \n');
fprintf('  9) Triangulation with linear interpolation \n');
gridmet = input('What is your Gridding method?\n ');
switch gridmet
     case 1
           met = 2;
     case 2
           met = 1;
     case 3
           met = 3;
     case 4
           met = 4;
     case 5
           met = 5;
     case 6
           met = 6;
     case 7
           met = 7;          
     case 8
           met = 8;
     case 9
           met = 9;
     otherwise 
           met = 0;
end
fprintf('\n');
fprintf('Please, choose the type of file in which you will save  your grid: \n');
fprintf('  1) [.txt] ASCII text file \n');
fprintf('  2) [.dat] ASCII Data \n');
fprintf('  3) [.grd] GS ASCII Grid File Format \n');
ext = input('What is your type of file?\n ');
switch ext
                 case 1
                             extension = '.txt';
                 case 2
                             extension = '.dat';
                 case 3
                             extension = '.grd';
                 otherwise 
                             extension = 0;
end
fprintf('\n');
return