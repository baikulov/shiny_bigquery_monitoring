FROM rocker/shiny
RUN sudo apt-get update
RUN sudo apt-get install -y libpq-dev
# Download and install library
RUN R -e 'install.packages(c("bs4Dash", "httr", "DBI", "bigrquery", "readr"))'
COPY . /srv/shiny-server/
# copy the app to the image COPY shinyapps /srv/shiny-server/
# make all app files readable (solves issue when dev in Windows, but building in Ubuntu)
RUN chmod -R 777 /srv/shiny-server/keys
EXPOSE 3838