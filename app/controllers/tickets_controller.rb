class TicketsController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :find_ticket, only: [:edit, :destroy, :update, :status]

  def index
    @tickets = Ticket.all
  end

  def new
    @ticket = Ticket.new
  end

  def create
    @ticket = Ticket.new(ticket_attributes)
    @ticket.user = current_user
    if @ticket.save
      redirect_to tickets_path
    else
      render :new
    end
  end

  def update
    if @ticket.update_attributes(ticket_attributes)
      redirect_to @ticket, notice: "success update"
    else
      render :edit
    end

  end

  def destroy

    if @ticket.destroy
      redirect_to tickets_path
    else
      redirect_to tickets_path, alert: "couldn't delete your ticket"
    end

  end

  def status
    respond_to do |format|
      @ticket.status = !@ticket.status
      if @ticket.save
        format.html { redirect_to tickets_path, notice: "Marked Done!" }
        format.js { render }
      else
        format.html { redirect_to tickets_path, alert: "error" }
        format.js { render js: "alert('ERROR');" }
      end
    end
  end


  def edit
  end


  private

  def ticket_attributes
    params.require(:ticket).permit(:title, :description)
  end

  def find_ticket
    @ticket = current_user.tickets.find(params[:id])
    redirect_to root_path, alert: "Access Denied" unless @ticket
  end


end
