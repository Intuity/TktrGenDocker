FROM ubuntu:16.04
MAINTAINER Peter Birch <peter@lightlogic.co.uk>

# Update aptitude
RUN sed 's/main$/main universe/' -i /etc/apt/sources.list
RUN apt-get update
RUN apt-get upgrade -y

# Set debconf to run non-interactively
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# Install WKHTMLToPDF
RUN apt-get install -y build-essential xorg openssl libssl-dev git
RUN apt-get install -y apt-transport-https ca-certificates curl python rsync software-properties-common wget 
RUN apt-get install -y wkhtmltopdf pdftk
RUN apt-get install -y xvfb

# Build a script to run WKHTMLToPDF headless
RUN mkdir -p /usr/bin/my_alias
RUN echo "xvfb-run -a --server-args=\"-screen 0, 1024x768x24\" /usr/bin/wkhtmltopdf -q \$*" > /usr/bin/my_alias/wkhtmltopdf 
RUN chmod +x /usr/bin/my_alias/wkhtmltopdf
ENV PATH /usr/bin/my_alias:$PATH

# Install NVM & Node version 0.12.7
RUN /bin/bash -c "wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.33.2/install.sh | bash \
    && source $HOME/.nvm/nvm.sh \
    && nvm install 0.12.7 \
    && nvm alias default 0.12.7 \
    && nvm use default"

ENV NODE_PATH /root/.nvm/versions/node/v0.12.7/lib/node_modules
ENV PATH      $PATH:/root/.nvm/versions/node/v0.12.7/bin

# Get TktrGen from GitHub and install it
RUN mkdir -p /usr/src/TktrGen
WORKDIR /usr/src/TktrGen
RUN git clone https://github.com/Intuity/TktrGen.git
RUN /bin/bash -c "cd TktrGen ; source $HOME/.nvm/nvm.sh ; npm install"

# Update template, fonts, etc.
WORKDIR /usr/src/TktrGen/TktrGen
RUN apt-get install -y zip unzip
RUN wget http://intuity-design.co.uk/JuneEvent.zip
RUN unzip JuneEvent.zip
RUN rm -rf Templates
RUN rm -rf Images
RUN cp -rf JuneEvent/Templates ./
RUN cp -rf JuneEvent/Images ./
RUN mkdir /usr/share/fonts/truetype/custom
RUN cp -rf JuneEvent/Fonts/* /usr/share/fonts/truetype/custom
RUN chmod -R 755 /usr/share/fonts/truetype/custom
RUN fc-cache -f -v
RUN mkdir -p /usr/src/TktrGen/TktrGen/{digitals,output}
RUN rm /usr/src/TktrGen/TktrGen/tickets.csv
RUN ln -s /usr/src/TktrGen/TktrGen/output/tickets.csv /usr/src/TktrGen/TktrGen/tickets.csv

# Run the digital ticket 
ENTRYPOINT ["node"]
CMD ["./interactive.js"]
#CMD ["/bin/bash"]
