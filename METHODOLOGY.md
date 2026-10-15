# How HSG allocates HSO funding

This is the method the Harris Student Government (HSG) Finance Committee uses to split each quarter's budget among Harris Student Organizations (HSOs). The settings below are the Fall 2026 values; each quarter's values are in `data/<quarter>/parameters.csv`.

## 1. Two parts to every allocation

| Part | Share of budget | How it is split |
|---|---|---|
| Flat share | 25% | Equally among every HSO that applied on time |
| Flexible share | 75% | In proportion to **committee score × eligible request** |

```
flexible share for an HSO = flexible pool × (its score × its eligible request)
                                          ÷ (sum of score × eligible request over all applicants)

allocation = flat share + flexible share,
             capped at flat share + eligible request, rounded to the nearest $10
```

No HSO is given more than it can spend under the rules. There is no other per-club cap.

## 2. Eligible request

Eligible request is the amount an HSO asked for, minus spending above these limits. Each event is classified from the HSO's own description, using this test in order:

1. **Cultural:** the food or cultural practice *is* the program. All food is fundable.
2. **Programmatic:** substantive content (a speaker, panel, training or service activity) that would happen even without food. Food is fundable up to **60%** of the event budget.
3. **Social:** anything else, where the gathering itself is the point. HSG covers up to **$400** per event.

A social event co-hosted by k HSOs carries a limit of k × $400, but only when the partner HSO lists the same event in its own application. Alcohol counts as food and must follow University policy. Spending above these limits isn't banned; HSOs can cover it with rollover, RSO funds or sponsors.

## 3. Committee score

Each reviewer scores each HSO from 1 (weak) to 5 (excellent) in three areas:

| Area | Weight | Strong applications |
|---|---|---|
| Financial Stewardship | 30% | Itemized, realistic budgets; rollover used first; asking only for the gap |
| Collaboration & Inclusion | 25% | Co-hosted events; open to all of Harris; broadens access |
| Impact | 45% | Clear policy substance; strong reach for the cost; fills a gap no other HSO covers |

An **automatic reviewer** scores every HSO from its own application data and counts as one voice:

* Stewardship = 5 − 4 × (rollover ÷ request), between 1 and 5. Rollover is each HSO's HarrisHub "Available" balance on the date allocations are calculated, less any approved earmarked funds (section 4), so every club is measured from the same source.
* Collaboration = 1 with no declared collaborations, otherwise (collaborations + 2), up to 5; the HSO Fair counts as one
* Impact = 1 + 4 × (expected attendees ÷ 300), up to 5

The **committee score** is the average of every reviewer's weighted score and the automatic reviewer's weighted score. Reviewers recuse themselves from HSOs they belong to.

## 4. Rollover and earmarked funds

The committee treats an HSO's full HarrisHub "Available" balance as rollover that can go toward its events. An HSO can ask to have part of that balance set aside only if the money is restricted by someone outside the HSO:

* **External restriction:** a sponsor, donor or grant gave the money for a specific purpose or event.
* **Prior commitment:** a signed contract, deposit or invoice for a specific expense that isn't yet a pending expense in HarrisHub.

To claim it, list each earmarked amount in the application with its **source, the purpose it's restricted to, and documentation** (a sponsor email, agreement or invoice). Approved amounts are left out of rollover when Financial Stewardship is scored.

**What doesn't count:** money the HSO plans to save for its own purposes, such as an end-of-year event or a future quarter. Pending expenses already shown in HarrisHub don't count either, because the "Available" balance already subtracts them.

Earmarked money must be spent on its stated purpose. Any of it still unspent at the next allocation counts as regular rollover.

## 5. Overrides and appeals

* **Overrides:** the committee may change an allocation by hand only with a written justification; each adjustment is marked in the published report.
* **Appeals:** HSOs have 72 hours after receiving their event classifications to contest a classification, correct attendance, confirm co-hosts, update their rollover or claim earmarked funds. Classifications lock after that window.
