module SplitRatioProfileSetsHelper
  def strip_xml(profile)
    return profile.split("<\/srm>")
  end

  def strip_xml_entry(r,index)
    r.gsub("<srm>","").strip.insert(-1,"\n")
  end
end
