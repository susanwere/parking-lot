# frozen_string_literal: true

module Api
  class TicketsController < ApplicationController
    require 'securerandom'
    before_action :set_ticket, only: %i[show update destroy]

    # GET /tickets
    def index
      @tickets = Ticket.all

      render json: @tickets
    end

    # GET /tickets/1
    def show
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
      params.require(:ticket).permit(:barcode, :ticketedtime)
    end
  end
end
