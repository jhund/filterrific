# -*- coding: utf-8 -*-
#
# Adds reset_terriffilter_url to controllers and views
#
module Terriffilter
  module HasResetTerriffilterUrlMixin

    # Returns a url that can be used to reset the terriffilter params
    def reset_terriffilter_url(opts = {})
      url_for(
        { terriffilter: { reset_terriffilter: true } }.merge(opts)
      )
    end

  end
end
