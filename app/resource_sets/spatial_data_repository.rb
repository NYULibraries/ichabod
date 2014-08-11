class SpatialDataRepository < Ichabod::ResourceSet::Base
  self.prefix = 'sdr'
  self.source_reader_class = Ichabod::ResourceSet::SourceReaders::OaiDcFileReader
end
