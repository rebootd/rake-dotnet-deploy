PROJ_NAME = 'Sample'
DEV_FOLDER = 'dev-server'
PROD_FOLDER = 'live-server'
SLN_FILE = ".\\src\\#{PROJ_NAME}.sln"
# ------------------------------------------------------------------------
LOCAL_SQL = 'localhost'
DEV_SQL = 'devsql'
PROD_SQL = 'livesql'
LOCAL_DB = 'SampleDBLocal'
DEV_DB = 'SampleDBDev'
PROD_DB = 'CampleDB'
LOCAL_SQL_BACKUP = 'c:\\backups\\'
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
