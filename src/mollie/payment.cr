struct Mollie
  struct Payment < Base
    include Mollie::Mixins::Linkable

    enum Status
      Open
      Canceled
      Pending
      Expired
      Failed
      Paid
      Authorized

      def to_s
        super.downcase
      end
    end

    getter id : String
    getter description : String
    @[JSON::Field(key: "createdAt", converter: Mollie::Json::TimeFormatter)]
    getter created_at : Time
    getter status : String
    @[JSON::Field(key: "authorizedAt", converter: Mollie::Json::TimeFormatter)]
    getter authorized_at : Time
    @[JSON::Field(key: "paidAt", converter: Mollie::Json::TimeFormatter)]
    getter paid_at : Time
    getter amount : Mollie::Amount
    getter description : String
    getter method : String

    def open?
      status == Status::Open.to_s
    end

    def canceled?
      status == Status::Canceled.to_s
    end

    def pending?
      status == Status::Pending.to_s
    end

    def expired?
      status == Status::Expired.to_s
    end

    def failed?
      status == Status::Failed.to_s
    end

    def paid?
      status == Status::Paid.to_s
    end

    def authorized?
      status == Status::Authorized.to_s
    end
  end
end
