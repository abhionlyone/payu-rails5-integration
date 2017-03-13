class HomeController < ApplicationController
  skip_before_action :verify_authenticity_token

	
  FIELDS = [ :txnid, :amount, :productinfo, :firstname, :email, :udf1, :udf2, :udf3, :udf4,:udf5, :udf6, :udf7, :udf8, :udf9, :udf10 ]

	
	def index
	
  end
	

	def payment
	  @key = "gtKFFx"
    @salt =  "eCwWELxi"
    @options={:txnid => "#{Time.now.to_i}",
              :amount => 10.00,
              :productinfo => "Omnisling POS License",
              :firstname => "Abhilash",
              :email => "abhilas@gogreenbasket.com",
              :phone => "7411117841",
              :udf1 => "NO-VALUE",
              :udf2 => "NO-VALUE",
              :udf3 => "NO-VALUE",
              :udf4 => "NO-VALUE",
              :udf5 => "NO-VALUE"}
    @checksum = get_checksum(@key,@salt,@options)
	end
  
  def pay_success
    @response = params
    @key = "gtKFFx"
    @salt =  "eCwWELxi" 
    command = "check_payment"
    var1 = params[:mihpayid]
    checksum = get_checksum_for_verification(@key,@salt,command,var1)
    @verified_payment = check_payment(@key,command,var1,checksum)
    respond_to do |format|
      format.html { render :partial => '/home/message.html.erb' }
    end
  end

  def pay_failure
    @response = params
    respond_to do |format|
      format.html { render :partial => '/home/message.html.erb' }
    end
  end

  def message
  end

	private

  def get_checksum_for_verification(key,salt,command,options)
    Digest::SHA512.hexdigest([key, command ,*options, salt].join("|"))
  end

	def get_checksum(key,salt,options)	
    payload = FIELDS.map { |field| options[field] }
    Digest::SHA512.hexdigest([key, *payload, salt].join("|"))
  end

  def check_payment(key,command,var1,checksum)
    uri = URI.parse("https://test.payu.in/merchant/postservice.php?form=2")
    form_data = {"key":key,"command":command,"hash":checksum,"var1":var1}
    res = Net::HTTP.post_form(uri,form_data)
    success = res.body.include? ('"status":1')
    if success
      return true
    else
      return false
    end  
  end

end
