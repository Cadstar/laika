class InsuranceProviderSubscribersController < PatientDataChildController

  def edit

    if !@isoCountries
      @isoCountries = IsoCountry.find(:all, :order => "name ASC")
    end

    @insurance_provider_subscriber
    for insurance_provider in @patient_data.insurance_providers
      if (insurance_provider.insurance_provider_subscriber.id.to_s == params[:id])
        @insurance_provider_subscriber = insurance_provider.insurance_provider_subscriber
      end
    end

    render :partial  => 'edit', :locals => {:insurance_provider_subscriber =>  @insurance_provider_subscriber,
                                            :patient_data => @patient_data}
  end

  def update

    @insurance_provider_subscriber
    for insurance_provider in @patient_data.insurance_providers
      if (insurance_provider.insurance_provider_subscriber.id.to_s == params[:id])
        @insurance_provider_subscriber = insurance_provider.insurance_provider_subscriber
      end
    end

    @insurance_provider_subscriber.update_attributes(params[:insurance_provider_subscriber])
    @insurance_provider_subscriber.update_person_attributes(params)

    render :partial  => 'show', :locals => {:insurance_provider_subscriber =>  @insurance_provider_subscriber,
                                            :patient_data => @patient_data}
  end

end