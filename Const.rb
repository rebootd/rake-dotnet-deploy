PROJ_NAME = 'VesGbase'
DEV_FOLDER = 'devportal.vensureinc.com'
PROD_FOLDER = 'portal.vensureinc.com'
SLN_FILE = ".\\#{PROJ_NAME}\\#{PROJ_NAME}.sln"
# ------------------------------------------------------------------------
LOCAL_SQL = 'localhost'
DEV_SQL = 'pro-data1-dv'
PROD_SQL = 'pro-data1-dv'
LOCAL_DB = 'VesGBaseDev'
DEV_DB = 'VesGBaseDev'
PROD_DB = 'VesGBase'
LOCAL_SQL_BACKUP = 'c:\\backups\\sql\\'
DEV_SQL_BACKUP = 'c:\\backups\\'
PROD_SQL_BACKUP = 'c:\\backups\\'
# ------------------------------------------------------------------------
ROOT = File.dirname(__FILE__)
OUTPUT = ROOT + '/build/'
LOCAL_PATH = ".\\#{PROJ_NAME}"
LOCAL_OUTPUT = ".\\build\\_PublishedWebsites\\#{PROJ_NAME}"
LOCAL_COPY = '.\\deployed'
LOCAL_BACKUP = '.\\backup'
DEVPORTAL_DEST = "\\\\pro-iisoutside-dv\\c$\\inetpub\\#{DEV_FOLDER}"
DEVPORTAL_BACKUP = "\\\\pro-iisoutside-dv\\c$\\Backups\\#{DEV_FOLDER}"
PORTAL_DEST = "\\\\pro-iisoutside-dv\\c$\\inetpub\\#{PROD_FOLDER}"
PORTAL_BACKUP = "\\\\pro-iisoutside-dv\\c$\\Backups\\#{PROD_FOLDER}"
