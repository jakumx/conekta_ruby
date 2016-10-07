class ShopsController < ApplicationController

  def index
  end

  def create
    begin
      @charge = Conekta::Charge.create({
        "amount"=> (params['amount'].to_f * 100).to_i,
        "currency"=> params['currency'],
        "description"=> "Test charge",
        "reference_id"=> DateTime.now.to_s(:number),
        "card"=> params['conektaTokenId'],
        "details"=> {
          "name"=> params['name'],
          "phone"=> params['phone'],
          "email"=> params['email'],
          "customer"=> {
            "logged_in"=> true,
            "successful_purchases"=> 14,
            "created_at"=> 1379784950,
            "updated_at"=> 1379784950,
            "offline_payments"=> 4,
            "score"=> 9
          },
          "line_items"=> [{
            "name"=> "Box of Cohiba S1s",
            "description"=> "Imported From Mex.",
            "unit_price"=> (params['amount'].to_f * 100).to_i,
            "quantity"=> 1,
            "sku"=> "cohb_s1",
            "category"=> "food"
          }],
          "billing_address"=> {
            "street1"=> params['street1'],
            "street2"=> params['street2'],
            "city"=> params['city'],
            "state"=> params['state'],
            "zip"=> params['zip'],
            "country"=> params['country'],
            "tax_id"=> "xmn671212drx",
            "company_name"=>"X-Men Inc.",
            "phone"=> "77-777-7777",
            "email"=> "purshasing@x-men.org"
          }
        }
      })
    rescue Conekta::ParameterValidationError => e
      puts e.message 
      #alguno de los parámetros fueron inválidos
      @message = e.message_to_purchaser

    rescue Conekta::ProcessingError => e
      puts e.message 
      #la tarjeta no pudo ser procesada
      @message = e.message_to_purchaser

    rescue Conekta::Error => e
      puts e.message 
      #un error ocurrió que no sucede en el flujo normal de cobros como por ejemplo un auth_key incorrecto
      @message = e.message_to_purchaser
    end
  end

  def show
  end
end
