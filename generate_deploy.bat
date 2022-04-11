@echo off


if "%1"=="pull" ( 
 git pull origin hexo:hexo
) else (
 git add .
 git commit -m "%1"
 git push origin hexo:hexo
 hexo clean
 hexo g&&hexo d
)