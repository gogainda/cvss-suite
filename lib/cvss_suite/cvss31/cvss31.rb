# CVSS-Suite, a Ruby gem to manage the CVSS vector
#
# Copyright (c) 2019-2022 Siemens AG
# Copyright (c) 2022 0llirocks
#
# Authors:
#   0llirocks <http://0lli.rocks>
#
# This work is licensed under the terms of the MIT license.
# See the LICENSE.md file in the top-level directory.

require_relative '../cvss'
require_relative 'cvss31_base'
require_relative 'cvss31_temporal'
require_relative 'cvss31_environmental'
require_relative '../helpers/cvss31_helper'

module CvssSuite
  ##
  # This class represents a CVSS vector in version 3.1.
  class Cvss31 < Cvss
    ##
    # Returns the Version of the CVSS vector.

    def version
      3.1
    end

    ##
    # Returns the Base Score of the CVSS vector.

    def base_score
      check_validity
      Cvss31Helper.round_up(@base.score)
    end

    ##
    # Returns the Temporal Score of the CVSS vector.

    def temporal_score
      Cvss31Helper.round_up(Cvss31Helper.round_up(@base.score) * @temporal.score)
    end

    ##
    # Returns the Environmental Score of the CVSS vector.

    def environmental_score
      return temporal_score unless @environmental.valid?

      Cvss31Helper.round_up(@environmental.score(@base, @temporal))
    end

    private

    def init_metrics
      @base = Cvss31Base.new(@properties)
      @temporal = Cvss31Temporal.new(@properties)
      @environmental = Cvss31Environmental.new(@properties)
    end
  end
end
