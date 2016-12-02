clear all;
#files = glob('~/Desktop/ouyou/')
#for i=1:numel(files)
#  [~, name]=fileparts(files{i})
#  eval(sprintf('%s = load("%s", "utf8");', name, files{i}));
#endfor

filelist = readdir(pwd)
array_size = size(filelist,1)
for i=1:array_size
  #skip special files . and ..
  if (regexp (filelist{i,1}, "^\\.\\.?$"))
    continue;
  endif
  if (i!=3)
    continue;
  elseif  (i != array_size)
    continue;
  else
    l = imread(filelist{i,1})
    imagesc(l)
  endif
endfor
  
  


