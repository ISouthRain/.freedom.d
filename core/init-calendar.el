;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; calfw
(use-package calfw
  :ensure t
  :config
  (use-package calfw-org
    :ensure t)
  (use-package calfw-ical
    :ensure t
    )
  (use-package calfw-cal
    :ensure t
    )
  ;; Month
  (setq calendar-month-name-array
        ["一月" "二月" "三月" "四月" "五月"   "六月"
         "七月" "八月" "九月" "十月" "十一月" "十二月"])
  ;; Week days
  (setq calendar-day-name-array
        ["周末" "周一" "周二" "周三" "周四" "周五" "周六"])
  ;; First day of the week
  (setq calendar-week-start-day 0) ; 0:Sunday, 1:Monday
  (defun cfw:freedom-calendar ()
    (interactive)
    (cfw:open-calendar-buffer
     :contents-sources
     (list
      (cfw:org-create-source "Orange")  ; orgmode source
      (cfw:ical-create-source "RainISouth" "https://calendar.google.com/calendar/ical/isouthrain%40gmail.com/public/basic.ics" "Blue") ; google calendar ICS
      (cfw:ical-create-source "ChinaHoliday" "https://calendar.google.com/calendar/ical/zh-cn.china%23holiday%40group.v.calendar.google.com/public/basic.ics" "IndianRed") ; google calendar ICS
      )))
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; cal-china-x
(use-package cal-china-x
  :ensure t
  :after calendar
  :commands cal-china-x-setup
  :init (cal-china-x-setup)
  :config
  ;; Holidays
  (setq calendar-mark-holidays-flag t
        cal-china-x-important-holidays cal-china-x-chinese-holidays
        cal-china-x-general-holidays '((holiday-lunar 1 15 "元宵节")
                                       (holiday-lunar 7 7 "七夕节")
                                       (holiday-lunar 8 15 "中秋节")
                                       (holiday-fixed 3 8 "妇女节")
                                       (holiday-fixed 3 12 "植树节")
                                       (holiday-fixed 5 4 "青年节")
                                       (holiday-fixed 6 1 "儿童节")
                                       (holiday-fixed 9 10 "教师节")
                                       (holiday-fixed 10 1 "国庆节")
                                       )
        holiday-other-holidays '((holiday-fixed 2 14 "情人节")
                                 (holiday-fixed 4 1 "愚人节")
                                 (holiday-fixed 12 25 "圣诞节")
                                 (holiday-float 5 0 2 "母亲节")
                                 (holiday-float 6 0 3 "父亲节")
                                 (holiday-float 11 4 4 "感恩节"))
        holiday-custom-holidays '((holiday-lunar 7 29 "Happy Birthday")
                                  (holiday-lunar 2 3 "纪念奶奶"))
        calendar-holidays (append cal-china-x-important-holidays
                                  cal-china-x-general-holidays
                                  holiday-other-holidays
                                  holiday-custom-holidays)))
(provide 'init-calendar)
