function collection = Get_Collection( collectionId ) 

% This function creates an object of type collection for an already
% existing collection by using the id of that collection.
% Note: It only works for Windows OS
%       For a different OS path to config.ini file must be explicitly given

% Get the username of the current user
username=getenv('USERNAME');

% Generate the path to pyimeji configuration file
path = strcat('C:\Users\',username,'\AppData\Local\pyimeji\pyimeji\');

% Access and locate pyimeji config.ini
files = dir(fullfile(path, '*.ini'));

% Read and store user credentials from config file
fname = strcat(path,files(1).name);
[keys,~,~] = inifile(fname,'readall');

% Generate the bas url to make a GET request
base_url = strcat(keys{2,4},'rest/collections/',collectionId);

% Specify parameters for a GET request
options = weboptions('Username',keys{3,4},'Password',keys{4,4},...
                     'MediaType','application/json','RequestMethod','get');

% Make GET request for a collection                 
collection = webread(base_url,options);

end