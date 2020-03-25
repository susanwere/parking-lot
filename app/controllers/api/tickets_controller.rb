# frozen_string_literal: true

module Api
  class TicketsController < ApplicationController
    require 'securerandom'
    before_action :set_ticket, only: %i[show update destroy]
    before_action :calculate_price, only: %i[show update destroy]

    # GET /tickets
    def index
      @tickets = Ticket.all

      json_response(@tickets, :ok)
    end

    # GET /tickets/1
    def show
      json_response(@ticket, :ok)
    end

    def get_by_barcode
      @ticket = Ticket.find_by_barcode(params[:barcode])
      if @ticket
        calculate_price
        json_response(@ticket, :ok)
      else
        raise ActiveRecord::RecordNotFound
      end
    end

    def check_payment
      if @ticket.paid?
        json_response({error: "This ticket has already been paid for"}, :unprocessable_entity)
        return
      elsif ticket_params[:price_cents] == @ticket.price_cents
        @ticket.previous_price_cents = params[:ticket][:price_cents]
        params[:ticket][:price_cents] = 0
      elsif ticket_params[:price_cents] < @ticket.price_cents
        json_response({error: "The payment is insuficient. Kindly pay €#{@ticket.price_cents}"}, :unprocessable_entity)
        return
      elsif ticket_params[:price_cents] > @ticket.price_cents
        json_response({error: "The payment is in excess. Kindly pay €#{@ticket.price_cents}"}, :unprocessable_entity)
        return
      end
    end

    def check_payment_option
      payment_option = Ticket.payment_options[ticket_params[:payment_option]] 
      if payment_option
        params[:ticket][:payment_option] = payment_option
      else
        json_response({error: "The payment option is invalid. Use cash, credit_card or debit_card"}, :unprocessable_entity)
        return
      end
    end

    def check_payment_state
      @ticket = Ticket.find_by_barcode(params[:barcode])
      if @ticket.payment_time
        time_difference = (Time.now.in_time_zone('GMT') - @ticket.payment_time.in_time_zone('GMT'))/60
        if @ticket.price_cents == 0 && !(time_difference > 15)
          @ticket[:paid] = true
          json_response({paid: "Payment has been made for this ticket"}, :ok)
        else
          @ticket.price_cents = @ticket.previous_price_cents
          @ticket.paid = false
          @ticket.save!
          json_response({unpaid: "You need to make another payment"}, :unprocessable_entity)
          return
        end
      else
        json_response({unpaid: "You need to make a payment"}, :unprocessable_entity)
        return
      end
    end

    def payment
      @ticket = Ticket.find_by_barcode(params[:barcode])
      calculate_price

      return unless check_payment
      return unless check_payment_option

      @ticket[:payment_time] = Time.now()

      if @ticket.update(ticket_params)
        json_response(@ticket, :ok)
      else
        json_response(@ticket.errors, :unprocessable_entity)
      end

    end

    # POST /tickets
    def create
      @ticket = Ticket.new(barcode: SecureRandom.hex(8), ticketedtime: Time.now)

      if @ticket.save
        json_response(@ticket, :created)
      else
        json_response(@ticket.errors, :unprocessable_entity)
      end
    end

    # PATCH/PUT /tickets/1
    def update
      if @ticket.update(ticket_params)
        render json: @ticket
      else
        json_response(@ticket.errors, :unprocessable_entity)
      end
    end

    # DELETE /tickets/1
    def destroy
      @ticket.destroy
    end

    def calculate_price
      number_of_times = ((Time.now.in_time_zone('UTC') - @ticket[:ticketedtime].in_time_zone('UTC'))/3600).to_s.split(".")
      if @ticket[:price_cents] != (2 * number_of_times[0].to_i)
        @ticket[:price_cents] = (2 * number_of_times[0].to_i)
        @ticket.save!
      end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_ticket
      @ticket = Ticket.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def ticket_params
      params.require(:ticket).permit(:barcode, :ticketedtime, :price_cents, :paid, :payment_option, :payment_time)
    end
  end
end
