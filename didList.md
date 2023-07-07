* These part is vague since stuff happened yesterday and I'm sleepy af
1. ubuntu version 18.04 in order to have mysql 5.7 and php 7.2
1. install mysql 5.7
2. install php 7.2
1. install nodejs v14. 
3. install bower globally
5. reverse proxy in apache
6. follow the readme with great attention. 
7. install composer in a weird faction
8. setup dns and subdomains redirecting to the server
9. setup reverse proxy for main site, contest site, and teachers
10. set the languages for the contest site. 
11. set the regions for the teacher interface for the new county IR
12. set the language translations for the teacher interface.
13. changed some of the dependencies location (from bitbucket to github) (think it was bower?)
14. changed casing of France-IOI in the dependencaies of the composer.
15. lib-curl was somewhere in the code, got changed to lib-curl.
16. changed some of the dbv migrations since they were not compatible.
## do phpinfo() to get the installed stuff alongside php
* below are steps noted when they were being done:
1. installed php-mbstring