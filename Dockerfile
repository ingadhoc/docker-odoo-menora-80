FROM adhoc/odoo:8.0
MAINTAINER Damian Soriano <ds@ingadhoc.com>

ENV REFRESHED_AT 2014-08-30

# Update odoo server
WORKDIR /opt/odoo/server/
RUN git pull
RUN git checkout 8.0
RUN python setup.py install

RUN mkdir -p /opt/odoo/sources
WORKDIR /opt/odoo/sources

# ADHOC addons
RUN git clone https://github.com/ingadhoc/odoo-addons.git
RUN git clone https://github.com/ingadhoc/odoo-argentina.git
RUN pip install geopy==0.95.1 BeautifulSoup
RUN git clone https://github.com/menora/odoo-menora
RUN git clone https://github.com/ingadhoc/aeroo_reports.git
RUN pip install genshi==0.6.1 http://launchpad.net/aeroolib/trunk/1.0.0/+download/aeroolib.tar.gz

# Checkout last for master or specific for testing or release
RUN git --work-tree=/opt/odoo/sources/odoo-addons --git-dir=/opt/odoo/sources/odoo-addons/.git checkout master
RUN git --work-tree=/opt/odoo/sources/odoo-argentina --git-dir=/opt/odoo/sources/odoo-argentina/.git checkout master
RUN git --work-tree=/opt/odoo/sources/odoo-menora --git-dir=/opt/odoo/sources/odoo-menora/.git checkout master
RUN git --work-tree=/opt/odoo/sources/aeroo_reports --git-dir=/opt/odoo/sources/aeroo_reports/.git checkout master

RUN sudo -H -u odoo /opt/odoo/server/odoo.py --stop-after-init -s -c /opt/odoo/odoo.conf --db_host=odoo-db --db_user=odoo-menora-80 --db_password=odoo-menora-80 --addons-path=/opt/odoo/server/openerp/addons,/opt/odoo/server/addons,/opt/odoo/sources/odoo-addons,/opt/odoo/sources/odoo-argentina,/opt/odoo/sources/odoo-menora/addons,/opt/odoo/sources/aeroo_reports

CMD ["sudo", "-H", "-u", "odoo", "/opt/odoo/server/odoo.py", "-c", "/opt/odoo/odoo.conf"]
