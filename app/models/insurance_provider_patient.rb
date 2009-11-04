class InsuranceProviderPatient < ActiveRecord::Base

  strip_attributes!

  belongs_to :coverage_role_type

  include InsuranceProviderChild

  include PersonLike
  

  def requirements
    {
      :member_id => :hitsp_r2_optional,
      :start_coverage_date => :hitsp_r2_optional,
      :end_coverage_date => :hitsp_r2_optional,
      :date_of_birth => :required,
      :coverage_role_type_id => :required
    }
  end


  def to_c32(xml)
    xml.participant("typeCode" => "COV") do
      xml.participantRole("classCode" => "PAT") do
        if coverage_role_type
          xml.code("code" => coverage_role_type.code,
                   "displayName" => coverage_role_type.name,
                   "codeSystem" => "2.16.840.1.113883.5.111",
                   "codeSystemName" => "RoleCode")
        end
        xml.playingEntity do
          person_name.try(:to_c32, xml)
          if date_of_birth.present?
            xml.sdtc(:birthTime, "value" => date_of_birth.to_s(:brief))
          end
        end
      end
    end
  end

  def randomize(reg_info)
    self.person_name = PersonName.new
    self.address = Address.new
    self.telecom = Telecom.new

    self.person_name.first_name = reg_info.person_name.first_name
    self.person_name.last_name = reg_info.person_name.last_name
    self.address.street_address_line_one = reg_info.address.street_address_line_one
    self.address.city = reg_info.address.city
    self.address.state = reg_info.address.state
    self.address.postal_code = reg_info.address.postal_code
    self.address.iso_country = reg_info.address.iso_country
    self.member_id = random_id()
    self.coverage_role_type = CoverageRoleType.find :random

    self.telecom.home_phone = reg_info.telecom.home_phone
    self.telecom.work_phone = reg_info.telecom.work_phone
    self.telecom.mobile_phone = reg_info.telecom.work_phone
    self.date_of_birth = reg_info.date_of_birth()

    self.start_coverage_date = DateTime.new(reg_info.date_of_birth.year + rand(DateTime.now.year - reg_info.date_of_birth.year),
                       rand(12) + 1, rand(28) + 1)
    self.end_coverage_date = DateTime.new(self.start_coverage_date.year + rand(DateTime.now.year - self.start_coverage_date.year),
                       rand(12) + 1, rand(28) + 1)
  end

protected

  def random_char()
    char = ('A'..'Z').to_a
    char[rand(24)]
  end

  def random_id()
    random_char() + random_char() + random_char() + (1000 + rand(8999)).to_s + random_char() + (10000 + rand(89999)).to_s
  end
 
end
