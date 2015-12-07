%-------------------------------------------------------------------------%
%   This is an example script for demonstrating the use of Python         %
%   Client for Imeji known as 'pyimeji' to upload images to the           %
%   dev or production server                                              %
%-------------------------------------------------------------------------%

%--------------------------------------------------------------------------
% We load an excel sheet to extract the metadata
[~,~,raw] = xlsread('C:\Users\malik\Desktop\Data');
EpidatIdlist = raw(:,1);

%--------------------------------------------------------------------------
% Here we specify path to the folder where the images are stored 
foldername = '\path\to\Bilder\';              % path
files = dir(fullfile(foldername, '*.jpg'));   % format of the images   
NoOfFiles = length(files);                    % total number of files

%--------------------------------------------------------------------------

% Create an instance of Imeji object from the python client
api = py.pyimeji.api.Imeji();

% Specify the metadata profile to reference
profile = py.dict(pyargs('id','krGDA8kbH9GdLAS','method','reference'));

% Create a new collection
collection = api.create('collection', pyargs('title','Title','profile',profile));

%--------------------------------------------------------------------------

% Since we are carrying out the upload in raw syntax, we need the statement
% and type URIs of each metadata field.  These are specified below   
stateUri_EpidatId = 'http://dev-faces.mpdl.mpg.de/imeji/statement/weEiD7J_oNrYDdjJ';
typeUri_EpidatId = 'http://imeji.org/terms/metadata#text';

stateUri_ArrangedBy = 'http://dev-faces.mpdl.mpg.de/imeji/statement/vQzV3V011Dd80Tpe';
typeUri_ArrangedBy = 'http://imeji.org/terms/metadata#conePerson';

stateUri_Position = 'http://dev-faces.mpdl.mpg.de/imeji/statement/p4nxKPBZdLzOfVB_';
typeUri_Position = 'http://imeji.org/terms/metadata#text';

stateUri_Row = 'http://dev-faces.mpdl.mpg.de/imeji/statement/0WGD8fVGOsL0UkfZ';
typeUri_Row = 'http://imeji.org/terms/metadata#text';

stateUri_Tomb = 'http://dev-faces.mpdl.mpg.de/imeji/statement/ncuMDuOl2OfKxoPz';
typeUri_Tomb = 'http://imeji.org/terms/metadata#text';

stateUri_EpidatURL = 'http://dev-faces.mpdl.mpg.de/imeji/statement/HtWxQPIhC_84eMDH';
typeUri_EpidatURL = 'http://imeji.org/terms/metadata#link';

stateUri_CaptionDate = 'http://dev-faces.mpdl.mpg.de/imeji/statement/CSR2ZA0Rp6OzZ8cp';
typeUri_CaptionDate = 'http://imeji.org/terms/metadata#date';

stateUri_CaptionType = 'http://dev-faces.mpdl.mpg.de/imeji/statement/O8cgOrSdE6PCXyeJ';
typeUri_CaptionType = 'http://imeji.org/terms/metadata#text';

stateUri_CaptionNo = 'http://dev-faces.mpdl.mpg.de/imeji/statement/MAafKiI_b7ngpXOh';
typeUri_CaptionNo = 'http://imeji.org/terms/metadata#text';

stateUri_Graveyard = 'http://dev-faces.mpdl.mpg.de/imeji/statement/zEcldSl2npiaVPq';
typeUri_Graveyard = 'http://imeji.org/terms/metadata#geolocation';

stateUri_PersonBuried = 'http://dev-faces.mpdl.mpg.de/imeji/statement/EB75mojpUDkJ_Bwd';
typeUri_PersonBuried = 'http://imeji.org/terms/metadata#conePerson';

stateUri_BirthName = 'http://dev-faces.mpdl.mpg.de/imeji/statement/S5O5yOqnw6P7drO4';
typeUri_BirthName = 'http://imeji.org/terms/metadata#text';

stateUri_BirthDate = 'http://dev-faces.mpdl.mpg.de/imeji/statement/sgz8pdZkAnGfDq8z';
typeUri_BirthDate = 'http://imeji.org/terms/metadata#text';

stateUri_YearOfDeath = 'http://dev-faces.mpdl.mpg.de/imeji/statement/vri44EWLJkBjMBFc';
typeUri_YearOfDeath = 'http://imeji.org/terms/metadata#text';

stateUri_MonthOfDeath = 'http://dev-faces.mpdl.mpg.de/imeji/statement/MfjpmBzmflZ3iQ24';
typeUri_MonthOfDeath = 'http://imeji.org/terms/metadata#text';

stateUri_DayOfDeath = 'http://dev-faces.mpdl.mpg.de/imeji/statement/RT9LO2hjcni8lp8';
typeUri_DayOfDeath = 'http://imeji.org/terms/metadata#text';

stateUri_PlaceOfBirth = 'http://dev-faces.mpdl.mpg.de/imeji/statement/ohKpHy4QvYKkgkg';
typeUri_PlaceOfBirth = 'http://imeji.org/terms/metadata#geolocation';

stateUri_PlaceOfDeath = 'http://dev-faces.mpdl.mpg.de/imeji/statement/uB_HUYOm0Hv9Jz5a';
typeUri_PlaceOfDeath = 'http://imeji.org/terms/metadata#geolocation';

stateUri_HebrewName = 'http://dev-faces.mpdl.mpg.de/imeji/statement/8Z95tdkFqD7iyOSd';
typeUri_HebrewName = 'http://imeji.org/terms/metadata#text';

%--------------------------------------------------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
%   From here on we will start populating the metadata fields using       %
%   the parsed image captions and the provided Excel sheet.               %  
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% Metadata field: 'Arranged by'
OrganizationName = py.list({py.dict(pyargs('name','Organization Name'))});
ArrangedBy = py.dict(pyargs('familyName','Family name','givenName','Given name',...
                     'organizations',OrganizationName));
                 
url = 'www.some-url.com';
                 

% Run a counter for all the files which need to be uploaded 
for counter = 1:NoOfFiles   

    % Obtain Epidat-Id from the caption
    % Metadata field: 'Epidat-Id'
    EpidatId = files(counter).name(1:4);
    
    % Convert Epidat-Id to numeric value to compare in Excel sheet 
    EpidatIdnum = str2double(EpidatId);
    
    % Metadata field: 'Caption type'
    CaptionType = files(counter).name(5);
    switch CaptionType       
        case '_'
            CaptionType = 'Regulär';
        case 'r'
            CaptionType = 'Rückseite (r)';
        case 'd'
            CaptionType = 'Detailaufnahme (d)';
        case 's'
            CaptionType = 'Steinmetzsignatur (s)';
        case 'y'
            CaptionType = 'Symbol (y)';
        case 'o'
            CaptionType = 'Ornament (o)';
        case 'x'
            CaptionType = 'Schriftlos (x)';           
    end
    
    % Metadata field: 'Caption date'
    CaptionDate = strcat(files(counter).name(10:13),'-',files(counter).name(14:15),'-',files(counter).name(16:17));

    % Metadata field: Caption No
    CaptionNo = files(counter).name(19:20);    
    
    % An internal counter to count the number of persons in a single grave
    internalcounter = 1;
    
    % Metadata field: 'Graveyard' 
    Graveyard = py.dict(pyargs('name','Name of graveyard','longitude','NaN','latitude','NaN'));
     
    for subcounter = 2:length(EpidatIdlist)
        
        % A comparison of Epidat-Id from caption with the one in excel
        % sheet
        if EpidatIdlist{subcounter,1} == EpidatIdnum && isnumeric(EpidatIdlist{subcounter,1})
            
            % A number of metadata fields obtained from the excel sheet
            Position = raw{subcounter,2};
            Row = num2str(raw{subcounter,3});
            Tomb = num2str(raw{subcounter,4});
            FamilyName{internalcounter} = raw{subcounter,5};
            GivenName{internalcounter} = raw{subcounter,6};
            BirthName{internalcounter} = raw{subcounter,7};
            GeburtsDatum{internalcounter} = raw{subcounter,8};
            YearOfDeath{internalcounter} = num2str(raw{subcounter,9});
            MonthOfDeath{internalcounter} = num2str(raw{subcounter,10});
            DayOfDeath{internalcounter} = num2str(raw{subcounter,11});
            PlaceOfBirth{internalcounter} = raw{subcounter,12};                             
            PlaceOfDeath{internalcounter} = raw{subcounter,13};                                           
            HebrewName{internalcounter} = raw{subcounter,14};
            
            % An internal counter to count the number of persons in a single grave
            internalcounter = internalcounter + 1;

        end
    end
    
    % Now we create a variable called 'metadata' and store in it the metadata
    % based on the number of people in a single grave
    switch internalcounter
            
        case 2


            PersonBuried = py.dict(pyargs('familyName',FamilyName{1},...
                                'givenName',GivenName{1}));


            % Metadata available for one Person(buried)                
            metadata = py.list({py.dict(pyargs('value',py.dict(pyargs('text',EpidatId)),...
                               'statementUri',stateUri_EpidatId,'typeUri',typeUri_EpidatId)),...
                               py.dict(pyargs('value',py.dict(pyargs('person',ArrangedBy)),...
                               'statementUri',stateUri_ArrangedBy,'typeUri',typeUri_ArrangedBy)),...
                               py.dict(pyargs('value',py.dict(pyargs('text',Position)),...
                               'statementUri',stateUri_Position,'typeUri',typeUri_Position)),...
                               py.dict(pyargs('value',py.dict(pyargs('text',Row)),...
                               'statementUri',stateUri_Row,'typeUri',typeUri_Row)),...
                               py.dict(pyargs('value',py.dict(pyargs('text',Tomb)),...
                               'statementUri',stateUri_Tomb,'typeUri',typeUri_Tomb)),...
                               py.dict(pyargs('value',py.dict(pyargs('link','Epidat Referenz','url',url)),...
                               'statementUri',stateUri_EpidatURL,'typeUri',typeUri_EpidatURL)),...
                               py.dict(pyargs('value',py.dict(pyargs('date',CaptionDate)),...
                               'statementUri',stateUri_CaptionDate,'typeUri',typeUri_CaptionDate)),...
                               py.dict(pyargs('value',py.dict(pyargs('text',CaptionType)),...
                               'statementUri',stateUri_CaptionType,'typeUri',typeUri_CaptionType)),...
                               py.dict(pyargs('value',py.dict(pyargs('text',CaptionNo)),...
                               'statementUri',stateUri_CaptionNo,'typeUri',typeUri_CaptionNo)),...
                               py.dict(pyargs('value',Graveyard,...
                               'statementUri',stateUri_Graveyard,'typeUri',typeUri_Graveyard)),...
                               py.dict(pyargs('value',py.dict(pyargs('person',PersonBuried)),...
                               'statementUri',stateUri_PersonBuried,'typeUri',typeUri_PersonBuried)),...
                               py.dict(pyargs('value',py.dict(pyargs('text',BirthName{1})),...
                               'statementUri',stateUri_BirthName,'typeUri',typeUri_BirthName)),...
                               py.dict(pyargs('value',py.dict(pyargs('text',GeburtsDatum{1})),...
                               'statementUri',stateUri_BirthDate,'typeUri',typeUri_BirthDate)),...
                               py.dict(pyargs('value',py.dict(pyargs('text',YearOfDeath{1})),...
                               'statementUri',stateUri_YearOfDeath,'typeUri',typeUri_YearOfDeath)),...
                               py.dict(pyargs('value',py.dict(pyargs('text',MonthOfDeath{1})),...
                               'statementUri',stateUri_MonthOfDeath,'typeUri',typeUri_MonthOfDeath)),...
                               py.dict(pyargs('value',py.dict(pyargs('text',DayOfDeath{1})),...
                               'statementUri',stateUri_DayOfDeath,'typeUri',typeUri_DayOfDeath)),...
                               py.dict(pyargs('value',py.dict(pyargs('name',PlaceOfBirth{1},'longitude','NaN','latitude','NaN')),...
                               'statementUri',stateUri_PlaceOfBirth,'typeUri',typeUri_PlaceOfBirth)),...
                               py.dict(pyargs('value',py.dict(pyargs('name',PlaceOfDeath{1},'longitude','NaN','latitude','NaN')),...
                               'statementUri',stateUri_PlaceOfDeath,'typeUri',typeUri_PlaceOfDeath)),...
                               py.dict(pyargs('value',py.dict(pyargs('text',HebrewName{1})),...
                               'statementUri',stateUri_HebrewName,'typeUri',typeUri_HebrewName))});


            
            
        case 3
            disp('2 Person')
            

            PersonBuried1 = py.dict(pyargs('familyName',FamilyName{1},...
                                'givenName',GivenName{1}));

            PersonBuried2 = py.dict(pyargs('familyName',FamilyName{2},...
                                'givenName',GivenName{2}));
                                               
                    
            % Metadata availabe for 2 buried persons
            metadata = py.list({py.dict(pyargs('value',py.dict(pyargs('text',EpidatId)),...
                               'statementUri',stateUri_EpidatId,'typeUri',typeUri_EpidatId)),...
                               py.dict(pyargs('value',py.dict(pyargs('person',ArrangedBy)),...
                               'statementUri',stateUri_ArrangedBy,'typeUri',typeUri_ArrangedBy)),...
                               py.dict(pyargs('value',py.dict(pyargs('text',Position)),...
                               'statementUri',stateUri_Position,'typeUri',typeUri_Position)),...
                               py.dict(pyargs('value',py.dict(pyargs('text',Row)),...
                               'statementUri',stateUri_Row,'typeUri',typeUri_Row)),...
                               py.dict(pyargs('value',py.dict(pyargs('text',Tomb)),...
                               'statementUri',stateUri_Tomb,'typeUri',typeUri_Tomb)),...
                               py.dict(pyargs('value',py.dict(pyargs('link','Epidat Referenz','url',url)),...
                               'statementUri',stateUri_EpidatURL,'typeUri',typeUri_EpidatURL)),...
                               py.dict(pyargs('value',py.dict(pyargs('date',CaptionDate)),...
                               'statementUri',stateUri_CaptionDate,'typeUri',typeUri_CaptionDate)),...
                               py.dict(pyargs('value',py.dict(pyargs('text',CaptionType)),...
                               'statementUri',stateUri_CaptionType,'typeUri',typeUri_CaptionType)),...
                               py.dict(pyargs('value',py.dict(pyargs('text',CaptionNo)),...
                               'statementUri',stateUri_CaptionNo,'typeUri',typeUri_CaptionNo)),...
                               py.dict(pyargs('value',Graveyard,...
                               'statementUri',stateUri_Graveyard,'typeUri',typeUri_Graveyard)),...
                               py.dict(pyargs('value',py.dict(pyargs('person',PersonBuried1)),...
                               'statementUri',stateUri_PersonBuried,'typeUri',typeUri_PersonBuried)),...
                               py.dict(pyargs('value',py.dict(pyargs('text',BirthName{1})),...
                               'statementUri',stateUri_BirthName,'typeUri',typeUri_BirthName)),...
                               py.dict(pyargs('value',py.dict(pyargs('text',GeburtsDatum{1})),...
                               'statementUri',stateUri_BirthDate,'typeUri',typeUri_BirthDate)),...
                               py.dict(pyargs('value',py.dict(pyargs('text',YearOfDeath{1})),...
                               'statementUri',stateUri_YearOfDeath,'typeUri',typeUri_YearOfDeath)),...
                               py.dict(pyargs('value',py.dict(pyargs('text',MonthOfDeath{1})),...
                               'statementUri',stateUri_MonthOfDeath,'typeUri',typeUri_MonthOfDeath)),...
                               py.dict(pyargs('value',py.dict(pyargs('text',DayOfDeath{1})),...
                               'statementUri',stateUri_DayOfDeath,'typeUri',typeUri_DayOfDeath)),...
                               py.dict(pyargs('value',py.dict(pyargs('name',PlaceOfBirth{1},'longitude','NaN','latitude','NaN')),...
                               'statementUri',stateUri_PlaceOfBirth,'typeUri',typeUri_PlaceOfBirth)),...
                               py.dict(pyargs('value',py.dict(pyargs('name',PlaceOfDeath{1},'longitude','NaN','latitude','NaN')),...
                               'statementUri',stateUri_PlaceOfDeath,'typeUri',typeUri_PlaceOfDeath)),...
                               py.dict(pyargs('value',py.dict(pyargs('text',HebrewName{1})),...
                               'statementUri',stateUri_HebrewName,'typeUri',typeUri_HebrewName)),...
                               py.dict(pyargs('value',py.dict(pyargs('person',PersonBuried2)),...
                               'statementUri',stateUri_PersonBuried,'typeUri',typeUri_PersonBuried)),...
                               py.dict(pyargs('value',py.dict(pyargs('text',BirthName{2})),...
                               'statementUri',stateUri_BirthName,'typeUri',typeUri_BirthName)),...
                               py.dict(pyargs('value',py.dict(pyargs('text',GeburtsDatum{2})),...
                               'statementUri',stateUri_BirthDate,'typeUri',typeUri_BirthDate)),...
                               py.dict(pyargs('value',py.dict(pyargs('text',YearOfDeath{2})),...
                               'statementUri',stateUri_YearOfDeath,'typeUri',typeUri_YearOfDeath)),...
                               py.dict(pyargs('value',py.dict(pyargs('text',MonthOfDeath{2})),...
                               'statementUri',stateUri_MonthOfDeath,'typeUri',typeUri_MonthOfDeath)),...
                               py.dict(pyargs('value',py.dict(pyargs('text',DayOfDeath{2})),...
                               'statementUri',stateUri_DayOfDeath,'typeUri',typeUri_DayOfDeath)),...
                               py.dict(pyargs('value',py.dict(pyargs('name',PlaceOfBirth{2},'longitude','NaN','latitude','NaN')),...
                               'statementUri',stateUri_PlaceOfBirth,'typeUri',typeUri_PlaceOfBirth)),...
                               py.dict(pyargs('value',py.dict(pyargs('name',PlaceOfDeath{2},'longitude','NaN','latitude','NaN')),...
                               'statementUri',stateUri_PlaceOfDeath,'typeUri',typeUri_PlaceOfDeath)),...
                               py.dict(pyargs('value',py.dict(pyargs('text',HebrewName{2})),...
                               'statementUri',stateUri_HebrewName,'typeUri',typeUri_HebrewName))});
            
    end
     
    % Here we specify the path along with the file name 
    path = strcat('\path\to\Bilder\',files(counter).name);
    
    % We display on the Command window which file is being uploaded
    Uploading = strcat('Uploading:  ',files(counter).name);
    disp(Uploading)
    
    % Here we upload the item and store the time it takes to upload each
    % image
    tic
    item = collection.add_item(pyargs('_file',path,'metadata',metadata));
    ElapsedTime(counter) = toc;
end
    
