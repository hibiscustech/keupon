class Company < ActiveRecord::Base

   belongs_to :merchant_profile

   has_attached_file :company_photo,
    :styles => {
      :thumb=> "100x100#",
      :small  => "150x150>" }
end
