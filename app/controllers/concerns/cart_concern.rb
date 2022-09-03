# frozen_string_literal: true

module CartConcern
  def respond_to_js_html
    unless flash[:alert]
      update_session_cart
      update_cart if user_signed_in?
    end
    respond_to do |format|
      format.js { render }
      format.html { redirect_back fallback_location: :root }
    end
  end

  def increase_item_quantity
    @cart.order_line_items.each do |order_line_item|
      if order_line_item.item == @item
        order_line_item.quantity_ordered += 1
        order_line_item.sub_total += @item.price
        return true
      end
      next
    end
    false
  end

  def decrease_item_quantity
    @cart.order_line_items.each do |order_line_item|
      if order_line_item.item == @item
        order_line_item.quantity_ordered -= 1
        order_line_item.sub_total -= @item.price
        delete_empty_line_item(order_line_item)
        return true
      end
      next
    end
    false
  end

  def delete_empty_line_item(order_line_item)
    return unless order_line_item.quantity_ordered.zero?

    @cart.order_line_items.delete(order_line_item)
    flash[:notice] = translate(:qunatity_zero)
  end

  def different_restaurant?
    return if @cart.restaurant == @item.restaurant

    flash[:alert] = translate(:already_another_restaurant)
    true
  end

  def line_item_present?
    @cart.order_line_items.each do |order_line_item|
      return true if order_line_item.item == @item
    end
    false
  end

  def session_cart
    return unless session[:cart]

    cart = Order.new(session[:cart])
    session[:cart_items]&.any? && cart.order_line_items.new(session[:cart_items])
    cart
  end

  def update_total_price
    @cart&.total_price = @cart.order_line_items.sum(&:sub_total)
  end

  def update_cart
    return unless @cart

    @cart.user = current_user
    if @cart.save
      if @cart.order_line_items.each(&:save)
        flash[:notice] = translate(:cart_updated)
      else
        flash[:alert] = translate(:line_item_not_updated)
      end
    else
      flash[:alert] = translate(:cart_not_updated)
    end
  end

  def update_session_cart
    session[:cart_items] = @cart.order_line_items.map(&:as_json).to_a
    update_total_price
    if @cart.order_line_items.empty?
      @cart.destroy
      @cart = nil
      session[:cart_items] = nil
    end
    session[:cart] = @cart.as_json
  end
end
