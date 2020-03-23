# frozen_string_literal: true

module Api
  class TicketsController < ApplicationController
    require 'securerandom'
    before_action :set_ticket, only: %i[show update destroy]
    before_action :calculate_price, only: %i[show update destroy]

    # GET /tickets
    def index
      @tickets = Ticket.all

      render json: @tickets
    end

    # GET /tickets/1
    def show
      render json: @ticket
    end

    def get_by_barcode
      @ticket = Ticket.find_by_barcode(params[:barcode])
      calculate_price
      render json: @ticket
    end

    # POST /tickets
    def create
      @ticket = Ticket.new(barcode: SecureRandom.hex(8), ticketedtime: Time.now)

      if @ticket.save
        render json: @ticket, status: :created
      else
        render json: @ticket.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /tickets/1
    def update
      if @ticket.update(ticket_params)
        render json: @ticket
      else
        render json: @ticket.errors, status: :unprocessable_entity
      end
    end

    # DELETE /tickets/1
    def destroy
      @ticket.destroy
    end

    def calculate_price
      number_of_times = ((Time.now - @ticket[:ticketedtime])/3600).to_s.split(".")
      if @ticket[:price_cents] != (2 * number_of_times[0].to_i)
        @ticket[:price_cents] = (2 * number_of_times[0].to_i)
        @ticket.save!
      end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_ticket
      @ticket = Ticket.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: {
        error: "Ticket with id #{params[:id]} not found",
        status: :not_found
      }
    end

    # Only allow a trusted parameter "white list" through.
    def ticket_params
      params.require(:ticket).permit(:barcode, :ticketedtime, :price_cents)
    end
  end
end
