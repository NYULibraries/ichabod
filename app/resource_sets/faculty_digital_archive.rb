class FacultyDigitalArchive < Ichabod::ResourceSet::Base
  self.prefix = 'fda'
  self.source_reader = :oai_dc_file_reader
  editor :fda_cataloger
  before_create :add_http_identifier_as_available

  private
  def add_http_identifier_as_available(*args)
    resource, nyucore = *args
    resource.identifier.each do |id|
      if id.include? "http://"
        nyucore.available = id
      end
    end
  end
end
