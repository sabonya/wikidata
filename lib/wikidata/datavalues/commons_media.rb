module Wikidata
  module DataValues
    class CommonsMedia < Wikidata::DataValues::Value

      def to_s
        data_hash.imagename
      end

      def resolve!
        query = {image: data_hash.imagename, thumbwidth: 150}
        puts "Getting: #{query}".yellow if Wikidata.verbose?
        r = Faraday.get('http://tools.wmflabs.org/magnus-toolserver/commonsapi.php', query)
        Nokogiri::XML(r.body)
      end

      def url
        resolved.search('file')[1].try(:content)
      end

    end
  end
end
