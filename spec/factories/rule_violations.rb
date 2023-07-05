FactoryBot.define do
  factory :rule_violation do
    association :alarm_rule
    status { RuleViolation.statuses.values.first }
    violation_text { I18n.t("rule_violations.violation_text", value: 10) }
    closed_at { nil }
  end
end
