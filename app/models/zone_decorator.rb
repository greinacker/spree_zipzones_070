# This is mostly copied from the Spree Zone methods,
# with added support for zipcode zone members
Spree::Zone.class_eval do

  attr_accessible :zipcode_ids

  def kind
    member = self.members.last
    case member && member.zoneable_type
    when "Spree::State"        then "state"
    when "Spree::Zone"         then "zone"
    when "Spree::Zipcode"      then "zipcode"
    else
      "country"
    end
  end


  # Check for whether an address.zipcode is available
  def include?(address)
    return false unless address
    
    members.any? do |zone_member|
      case zone_member.zoneable_type
      when "Spree::Country"
        zone_member.zoneable_id == address.country_id
      when "Spree::State"
        zone_member.zoneable_id == address.state_id
      when "Spree::Zipcode"
        zone_member.zoneable.name == address.zipcode
      else
        false
      end
    end
  end

  def zipcode_ids
    if kind == 'zipcode'
      members.collect(&:zoneable_id)
    else
      []
    end
  end

  def zipcode_ids=(ids)
    zone_members.destroy_all
    ids.reject{ |id| id.blank? }.map do |id|
      member = Spree::ZoneMember.new
      member.zoneable_type = 'Spree::Zipcode'
      member.zoneable_id = id
      members << member
    end
  end


end # Zone