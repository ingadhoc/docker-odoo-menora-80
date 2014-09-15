FROM adhoc/odoo:8.0
MAINTAINER Damian Soriano <ds@ingadhoc.com>

ENV REFRESHED_AT 2014-08-30

RUN mkdir -p /opt/odoo/sources
WORKDIR /opt/odoo/sources

# ADHOC addons
RUN git clone https://github.com/ingadhoc/odoo-addons.git
RUN git clone https://github.com/ingadhoc/odoo-argentina.git
RUN pip install geopy==0.95.1 BeautifulSoup
RUN git clone https://github.com/ingadhoc/aeroo_reports.git
RUN bzr branch lp:menora
RUN pip install genshi==0.6.1 http://launchpad.net/aeroolib/trunk/1.0.0/+download/aeroolib.tar.gz

# Checkout last for master or specific for testing or release
RUN git --work-tree=/opt/odoo/sources/odoo-addons --git-dir=/opt/odoo/sources/odoo-addons/.git checkout master
RUN git --work-tree=/opt/odoo/sources/odoo-argentina --git-dir=/opt/odoo/sources/odoo-argentina/.git checkout master
RUN git --work-tree=/opt/odoo/sources/aeroo_reports --git-dir=/opt/odoo/sources/aeroo_reports/.git checkout master

RUN sudo -H -u odoo /opt/odoo/server/odoo.py --stop-after-init -s -c /opt/odoo/server/odoo.conf --db_host=odoo-db --db_user=odoo --db_password=odoo --addons-path=/opt/odoo/server/openerp/addons,/opt/odoo/server/addons,/opt/odoo/sources/odoo-addons,/opt/odoo/sources/odoo-argentina,/opt/odoo/sources/aeroo_reports

# Update odoo server
WORKDIR /opt/odoo/server/
RUN git checkout 8.0
RUN python setup.py install

CMD ["sudo", "-H", "-u", "odoo", "/opt/odoo/server/odoo.py", "-c", "/opt/odoo/server/odoo.conf"]