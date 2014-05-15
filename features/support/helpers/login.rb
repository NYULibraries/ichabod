module IchabodFeatures
  module Login
    def format_pds_handle(pds_handle)
      pds_handle.gsub(/ /,"_")
    end
  end
end
