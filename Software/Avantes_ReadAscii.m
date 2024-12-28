function dat = Avantes_ReadAscii(filename, varargin)
%AVANTES_READASCII Import data from an AvaSoft ASCII exported file 
%  DAT = AVANTES_READASCII(FILENAME) reads data from text file
%  FILENAME for the default selection.  Returns the data as a table.
%
%  DAT = AVANTES_READASCII(___,Name,Value) accepts Name/Value property
%  pairs:
%     pathlength_m   Cuvette pathlength in meters (scalar, default 0.050)
%     minmax_wave_nm Wavelength range in nm to extract from file (1x2 
%     vector [min max], default [350 750])
% 
%  Examples:
%  dat = Avantes_ReadExportedAscii("okee_2024-10-18_locb_raw_a.txt");
%  dat = Avantes_ReadExportedAscii("okee_2024-10-18_locb_raw_a.txt", ...
%            'pathlength_m',0.050, 'minmax_wave_nm',[390 750]));
%
% NOTE that this function expects the ASCII file to contain the
% Transmittance column.
%
% WHS 21-Oct-2024 Initial version

p = inputParser;
addRequired(p,'filename',@ischar);
addParameter(p,'pathlength_m',0.050, @(x)validateattributes(x,{'numeric'}, ...
                    {'nonempty', 'scalar', '>=',0.0001, '<=',10}));
addParameter(p,'minmax_wave_nm',[350 750], @(x)validateattributes(x,{'numeric'}, ...
                    {'nonempty', 'increasing', 'size',[1 2], '>=',100, '<=',1000}));
parse(p,filename,varargin{:});



% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 5);

% Specify range and delimiter
opts.DataLines = [1, Inf];
opts.Delimiter = ";";

% Specify column names and types
opts.VariableNames = ["Wave", "Sample", "Dark", "Reference", "Transmittance"];
opts.VariableTypes = ["double", "double", "double", "double", "double"];

% Specify file level properties
opts.ImportErrorRule = "omitrow";
opts.MissingRule = "omitrow";
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Import the data
dat = readtable(filename, opts);

% TODO: Be smart about loading in the ASCII data table and not assuming the
% proper variables are available. For example, only calculate Beamc if the
% Transmittance variable is present.
% if ismember('Transmittance', dat.Properties.VariableNames)
% ...
% end

dat.Beamc = (-1/p.Results.pathlength_m)*log(dat.Transmittance/100);

idxBadWave = dat.Wave<p.Results.minmax_wave_nm(1) | dat.Wave>p.Results.minmax_wave_nm(2);

dat(idxBadWave,:) = [];

end