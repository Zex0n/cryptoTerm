module ApplicationHelper
  
  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def css_nav_item(controller_name)
    if controller_name.is_a?(Array)
      "active"  if controller_name.include?(@top_menu) or (@top_menu == nil and controller_name.include?(controller.controller_name))
    else
      "active"  if @top_menu == controller_name or (@top_menu == nil and controller.controller_name == controller_name)
    end
  end

  def price_format(price, precision = 8)
    if price == 0
      "0.00"
    # elsif price < 1
    else
      number_with_precision price, precision: precision
    # else
    #   number_with_precision price, precision: 3
    end
  end

  def btc_format(price, options = {colored: true, bold: true, precision: 8})
    html_class = []
    output = price == 0 ? "฿#{number_with_precision 0, precision: options[:precision]}" : "฿#{number_with_precision price, precision: options[:precision]}"
    
    html_class << "bold" if options[:bold] and (price > 1 or price < -1)
    html_class << "red" if options[:colored] and price < 0
    html_class << "green" if options[:colored] and price > 0

    
    content_tag(:span, output, class: html_class.join(" "))
  end

  def  percent_calculate (price1, price2)
    # if price2 > price1
      number = ((price1 != 0) ? (((price2.to_f - price1.to_f) / price1.to_f) * 100) : 0.0)
      # number = ((price1 != 0) ? ((price2.to_f / price1.to_f) * 100) : 0.0)
    # else
    #   number = ((price1 != 0) ? (((price2.to_f - price1.to_f) / price1.to_f) * 100) : 0.0)
    # end

    # 100*(y-x)/x
    per = "#{number_with_precision number, precision: 2}%"
    content_tag(:span,per)
  end


end
