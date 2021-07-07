require 'test_helper'

class PatientTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "patient_count" do
    assert_equal 2, Patient.count
    patient3 = create(:patient, :password => '12312341')
    patient4 = create(:patient, :password => '12312341')
    assert_equal 4, Patient.count
    Rails::logger.debug Patient.pluck(:email)
  end
end
