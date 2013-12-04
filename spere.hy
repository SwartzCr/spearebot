(import json)

(defn convert-to-array [text]
    (list (filter (fn [x] (!= x ""))
       (map (fn [x] (.split x "\n")) (.split text "\n\n")))))

(defn read-in [filename]
  (with [f (open filename)]
        (.decode
          (.read f)
          "utf-8")))

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
  


