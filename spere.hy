(import json)

(defn convert-to-array [text]
    (list (filter (fn [x] (!= x ""))
       (map (fn [x] (.split x "\n")) (.split text "\n\n")))))
;  (setv pars (enumerate out))
;  (for [(, idx par) pars]
;    (setv lines (enumerate par))
;    (for [(, idx line) lines]
;      (setv (get par idx)
;            (.strip line)))
;    (setv (get out idx) par)))

(defn read-in [filename]
  (with [f (open filename)]
        (.decode
          (.read f)
          "utf-8")))

(defn uncap [outer-lines]
  (setv enum-o-lines (enumerate outer-lines))
  (for [(, idx inner-line) enum-o-lines]
    (setv (get enum-o-line idx)
          (uncap-helper inner-line))))

(defn uncap-helper [inner-line]
  (for [line inner-lines]
    (if (> (len line)  1)
      (do (setv enum-line (enumerate line))
        (next enum-line)
        (for [(, idx line) enum-line]
          (setv (get line idx)
                (+ (.lower (slice sub-line 0 1))
                   (slice sub-line 1))))))))

(defn chunky [things]
  (setv buf "")
  (for [thing things]
    (if (< (+ (len buf) (len thing)) 140)
        (setv buf (.join " " [(.strip buf) (.strip thing)]))
      (do
        (yield (.strip buf))
        (setv buf thing))))
  (yield (.strip buf)))


(defn twit-parse [line-list]
  (setv out [])
  (for [lines line-list]
    (if (> (len lines) 1)
      (for [line (list (chunky lines))]
        (.append out line))
      (.append out (.strip (get lines 0)))))
   out)

(defn write-out [json-thing path]
  (with [f (open path "w")]
        (json.dump json-thing f)))

(defn main [filename]
  (setv file (read-in filename))
  (setv arr (convert-to-array file))
  (setv out (twit-parse arr))
  (write-out out "testrun"))
  


