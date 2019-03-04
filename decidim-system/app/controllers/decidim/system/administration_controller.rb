# frozen_string_literal: true

class Decidim::System::AdministrationController < Decidim::System::ApplicationController
  def index
  end

  def backup
    send_file(dump_database)
  end

  private

  def dump_database
    time = Time.now.strftime("%F_%H-%M-%S")
    system(cmd(time))
    File.absolute_path(file_path(time))
  end

  def cmd(time)
    "pg_dump -Fc -h #{host} -d #{database} -f #{file_path(time)}"
  end

  def database
    ActiveRecord::Base.connection_config[:database]
  end

  def host
    ActiveRecord::Base.connection_config[:host]
  end

  def file_path(time)
    Rails.root.join("backup_#{database}_#{time}.psql")
  end
end
