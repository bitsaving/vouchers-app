
 
 
# encoding: utf-8

##
# Backup Generated: my_backup
# Once configured, you can run the backup with the following command:
#
# $ backup perform -t my_backup [-c <path_to_configuration_file>]
#
Model.new(:db_backup, 'Description for my_backup') do
  ##
  # Split [Splitter]
  #
  # Split the backup file in to chunks of 250 megabytes
  # if the backup file size exceeds 250 megabytes
  #
  split_into_chunks_of 250

  ##
  # MySQL [Database]
  #
  database MySQL do |db|
    # To dump all databases, set `db.name = :all` (or leave blank)
    db.name               = "voucher_production"
    db.username           = "root"
    db.password           = "vinsol@123"
    db.host               = "vouchers.domain4now.com"
    db.socket             = "/var/run/mysqld/mysqld.sock"

    # Note: when using `skip_tables` with the `db.name = :all` option,
    # table names should be prefixed with a database name.
    # e.g. ["db_name.table_to_skip", ...]
  end

  ##
  # Amazon Simple Storage Service [Storage]
  #
  # See the documentation on the Wiki for details.
  # https://github.com/meskyanichi/backup/wiki/Storages
  store_with S3 do |s3|
    # AWS Credentials
    s3.access_key_id     = "ID:AKIAJGLFIOGPHW6JIE6A"
    s3.secret_access_key = "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"
    # Or, to use a IAM Profile:
    # s3.use_iam_profile = true

    s3.region            = "us-east-1"
    s3.bucket            = "VoucherAppBackup"
  end
   ##
  # Gzip [Compressor]
  #
  compress_with Gzip

  ##
  # Mail [Notifier]
  #
  # The default delivery method for Mail Notifiers is 'SMTP'.
  # See the Wiki for other delivery options.
  # https://github.com/meskyanichi/backup/wiki/Notifiers
  #
 

end
