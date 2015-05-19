% 这个东西注册所有的路径，让他们里面的函数都可以直接使用。有个小小递归在里面
ignorelist = {'.', '..', '.svn', 'outdir', 'indir','OriginalCodes','tpTest'};
addMBenchPath(cd,ignorelist)

% Notes: 只是addpath没有 savePath ，所以在重启任务时经常需要重新执行这个命名，否则会出错。

