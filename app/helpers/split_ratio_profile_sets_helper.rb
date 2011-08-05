module SplitRatioProfileSetsHelper
  def strip_xml(profile)
    return profile.split("<\/srm>")
  end

  def strip_xml_entry(r,index)
    r.gsub("<srm>", (index+1).to_s + ") ").strip.insert(-1,"\n")
  end
end
